From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH 3/3] bnx2i: Add bnx2i iSCSI driver.
Date: Tue, 27 May 2008 07:38:19 -0700
Message-ID: <adave0z24o4.fsf@cisco.com>
References: <1211418386-18203-1-git-send-email-mchan@broadcom.com>
	<1211418386-18203-4-git-send-email-mchan@broadcom.com>
	<ada8wy07osq.fsf@cisco.com>
	<1211578969.26900.5.camel@dhcp-10-13-110-217.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1211578969.26900.5.camel@dhcp-10-13-110-217.broadcom.com> (Anil
	Veerabhadrappa's message of "Fri, 23 May 2008 14:42:49 -0700")
Sender: netdev-owner@vger.kernel.org
To: Anil Veerabhadrappa <anilgv@broadcom.com>
Cc: Michael Chan <mchan@broadcom.com>, davem@davemloft.net, michaelc@cs.wisc.edu, netdev@vger.kernel.org, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

 > 'bnx2id' is the user component in this solution. bnx2id daemon uses
 > socket calls to bind tcp ports in high range and hands them over to
 > driver. This is how iscsi driver tries to solve tcp port collision
 > issue. User daemon communicates with the driver using sysfs and tcp port
 > related functions are bnx2i_read_tcp_portd_*/bnx2i_write_tcp_portd_*
 > (reference: bnx2i_sysfs.c)

So you are creating sockets just to reserve TCP ports to avoid host
stack clashes with your offload engine?  Wasn't this approach strongly
rejected (in the context of iWARP) in the past?

 - R.
