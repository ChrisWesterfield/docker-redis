FROM redis:4.0.1
RUN apt-get update
RUN apt-get install supervisor munin munin-node munin-plugins-extra python-pip -y
COPY munin-node.conf /etc/munin/munin-node.conf
COPY processes.py /usr/share/munin/plugins/proccesses.py
RUN chmod +x /usr/share/munin/plugins/proccesses.py
RUN ln -s /usr/share/munin/plugins/proccesses.py /etc/munin/plugins/supervisor
RUN rm /etc/munin/plugins/df /etc/munin/plugins/df_inode /etc/munin/plugins/diskstats /etc/munin/plugins/exim_mailqueue /etc/munin/plugins/fw_packets /etc/munin/plugins/interrupts /etc/munin/plugins/if* /etc/munin/plugins/irqstats /etc/munin/plugins/munin_stats  /etc/munin/plugins/swap /etc/munin/plugins/users /etc/munin/plugins/vmstat
RUN echo "[supervisord_process]" > /etc/munin/plugin-conf.d/supervisord_process
RUN echo "          user root" >> /etc/munin/plugin-conf.d/supervisord_process
RUN echo "          env.url unix:///var/run/supervisor.sock" >> /etc/munin/plugin-conf.d/supervisord_process
RUN pip install PyMunin
RUN pip install redis
RUN apt-get purge gcc python-pip binutils -y
RUN apt-get autoremove -y
RUN apt-get autoclean
RUN ln -s '/usr/share/munin/plugins/redis_' '/etc/munin/plugins/redis_127.0.0.1_6379'
RUN ln -s '/usr/share/munin/plugins/redisstats' '/etc/munin/plugins/redisstats'
CMD /usr/bin/supervisord -n