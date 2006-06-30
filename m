From: "Keith Baker" <krbaker@metacarta.com>
Subject: MegaSAS Hang on Smart Query
Date: Thu, 29 Jun 2006 20:29:45 -0400 (EDT)
Message-ID: <3541.10.0.0.113.1151627385.squirrel@webmail.metacarta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from silene.metacarta.com ([65.77.47.18]:47809 "EHLO
	silene.metacarta.com") by vger.kernel.org with ESMTP
	id S964825AbWF3A3r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jun 2006 20:29:47 -0400
Received: from localhost (silene.metacarta.com [65.77.47.18])
	by silene.metacarta.com (Postfix) with ESMTP id B8E0F9F8B6
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jun 2006 20:29:46 -0400 (EDT)
Received: from silene.metacarta.com ([65.77.47.18])
	by localhost (silene.metacarta.com [65.77.47.18]) (amavisd-new, port 10024)
	with ESMTP id 28565-09 for <linux-scsi@vger.kernel.org>;
	Thu, 29 Jun 2006 20:29:45 -0400 (EDT)
Received: from webmail.metacarta.com (cone-peak.metacarta.com [65.77.47.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by silene.metacarta.com (Postfix) with ESMTP id D57D69F8B7
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jun 2006 20:29:45 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've been having a hang with 2.6.16.22 and the megasas driver.  I'm pretty
sure it has to do with a smartctl -a <logical drive>.  The SCSI layer gets
all sorts of in a twist.

megasas: waiting for 2 commands to complete
- repeats a bunch of times then -
sd 0:2:0:0: rejecting I/O to offline device

Given a bit of wisdom in a driver distributed by dell which mentioned the
controller not responding to a cache inqury...  isn't the correct thing to
do respond with some sort of unsupported response?  not just ignore the
query?

I've hunted around for patches around this problem but haven't found any,
of course "don't use smart against a logical drive" works, but I'm not the
only one using these boxes and it does cause the system to go down.

-- 
Keith Baker

MetaCarta, Inc

350 Massachusetts Ave, 4th Floor

Cambridge, MA 02139 USA

www.metacarta.com <http://www.metacarta.com>

