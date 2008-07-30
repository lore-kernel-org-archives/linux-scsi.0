From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
Date: Wed, 30 Jul 2008 14:35:51 -0700
Message-ID: <aday73jxdfs.fsf@cisco.com>
References: <200807300019.m6U0JkdY012558@localhost.localdomain>
	<4890C287.60508@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <4890C287.60508@pobox.com> (Jeff Garzik's message of "Wed, 30 Jul
	2008 15:35:35 -0400")
Sender: netdev-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Karen Xie <kxie@chelsio.com>, netdev@vger.kernel.org, open-iscsi@googlegroups.com, davem@davemloft.net, michaelc@cs.wisc.edu, swise@opengridcomputing.com, daisyc@us.ibm.com, wenxiong@us.ibm.com, bhua@us.ibm.com, divy@chelsio.com, dm@chelsio.com, leedom@chelsio.com, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

 > * From a networking standpoint, our main concern becomes how this
 > interacts with the networking stack.  In particular, I'm concerned
 > based on reading the source that this driver uses "TCP port stealing"
 > rather than using a totally separate MAC address (and IP).
 > 
 > Stealing a TCP port on an IP/interface already assigned is a common
 > solution in this space, but also a flawed one.  Precisely because the
 > kernel and applications are unaware of this "special, magic TCP port"
 > you open the potential for application problems that are very
 > difficult for an admin to diagnose based on observed behavior.

That's true, but using a separate MAC and IP opens up a bunch of other
operational problems.  I don't think the right answer for iSCSI offload
is clear yet.

 - R.
