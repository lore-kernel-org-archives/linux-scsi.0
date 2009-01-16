From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Fri, 16 Jan 2009 09:16:14 -0500
Message-ID: <497096AE.3080604@cybernetics.com>
References: <49625A67.3000304@cybernetics.com> <20090111022525I.fujita.tomonori@lab.ntt.co.jp> <496E4B93.4000507@cybernetics.com> <20090114213917.GB22543@kroah.com> <496E6853.1010005@s5r6.in-berlin.de> <496E6CE1.9040404@cybernetics.com> <496E7993.70307@s5r6.in-berlin.de> <496F4C7B.2030707@cybernetics.com> <496F62CC.8000007@s5r6.in-berlin.de> <496F7DB6.6090506@cybernetics.com> <496F84AA.9060708@s5r6.in-berlin.de> <496F8C91.9050208@cybernetics.com> <496FA001.1000501@s5r6.in-berlin.de> <496FAE09.2040207@cybernetics.com> <496FB168.6080407@s5r6.in-berlin.de> <496FB744.90501@cybernetics.com> <496FC5C3.1010401@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:2193 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbZAPOQQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jan 2009 09:16:16 -0500
In-Reply-To: <496FC5C3.1010401@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg KH <greg@kroah.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org

Stefan,

Thank you for all of your comments, and for you concern for the quality
of the code.  In the end, we all want the same thing, and we are all
trying to reach the same goal.  You have given me an alternate way of
looking at the problem.  I am still not sure which way this one will go,
but at the very least your objections will help me write better comments
and documentation about the controversial approach I am taking.

Tony

