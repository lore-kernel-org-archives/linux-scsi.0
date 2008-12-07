From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/3 2.6.29] cxgb3i -- driver fixes & updates
Date: Sat, 06 Dec 2008 23:53:56 -0800 (PST)
Message-ID: <20081206.235356.237924993.davem@davemloft.net>
References: <200812070709.mB779a5T020861@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37442
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751126AbYLGHx4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Dec 2008 02:53:56 -0500
In-Reply-To: <200812070709.mB779a5T020861@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kxie@chelsio.com
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com

From: Karen Xie <kxie@chelsio.com>
Date: Sat, 6 Dec 2008 23:09:36 -0800

> It is based on the cxgb3i branch of Mike's linux-2.6-iscsi tree. It needs the
> patch Mike sent several days ago on preparing the iscsi core libary for pdu
> offload (http://marc.info/?l=linux-scsi&m=122819956917473).

If this dependency exists I probably can't pull this into the
net-next-2.6 then, just FYI but you probably already understand
this :-)
