From: S Iremonger <exxsi@bath.ac.uk>
Subject: IP/ethernet/networking-over-SCSI.
Date: Tue, 25 Jan 2005 16:19:12 +0000 (GMT)
Message-ID: <Pine.GSO.4.53.0501251546570.25246@amos.bath.ac.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-net-owner@vger.kernel.org>
Sender: linux-net-owner@vger.kernel.org
To: linux-net@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


For some purposes at the moment, working IP-over-SCSI could be rather
  handy... ;-).

I can see some project(s) for this but I am not sure which actaully
  work.  Many seem to want to have a particular SCSI board....
In short, I am stuck with a particular SCSI board in some machine(s)
  (e.g. 'pizzabox' small machines with onboard SCSI).

Is there any implementation that just works over SG (scsi generic)
  interface etc. and hence controller independant?

This would need to be happy to work cross-architectures (MIPS, PPC,
  i386, etc.).

I would like any comments or pointers to working mechanisms/projects
  for this...  Even just a 'manual tunnel' would be good -- i.e. a
  userspace program that listens for a TCP connection from localhost,
  carries that over SG, to listening/replying version at the other
  end, that carries the data to a TCP-connection TO localhost at the
  other end.

In fact, at least so far as X11 goes, something similar that works
  at the UNIX socket layer would be nice, but then the 'reliability'
  needs to be implemented too, which is sortof reinventing the wheel,
  TCP does this anyway ;-), unless the SCSI connection with 'sg' can
  be considered truly reliable??

Comments welcome, please ;-).


--S Iremonger <exxsi@bath.ac.uk>
