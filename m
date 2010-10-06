From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [RFC v2 00/21] TCM Core and TCM_Loop patches for v2.6.37
Date: Wed, 06 Oct 2010 21:13:58 +0400
Message-ID: <4CACAE56.6090209@vlnb.net>
References: <1285195702-11421-1-git-send-email-nab@linux-iscsi.org>	 <20101006111621O.fujita.tomonori@lab.ntt.co.jp>	 <1286340405.5685.93.camel@haakon2.linux-iscsi.org>	 <20101006160434M.fujita.tomonori@lab.ntt.co.jp> <1286349898.5685.117.camel@haakon2.linux-iscsi.org> <4CAC833F.2010108@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:62615 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab0JFROs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2010 13:14:48 -0400
In-Reply-To: <4CAC833F.2010108@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, michaelc@cs.wisc.edu, hch@lst.de, hare@suse.de, James.Bottomley@suse.de, axboe@kernel.dk, bharrosh@panasas.com, jeff@garzik.org

Tejun Heo, on 10/06/2010 06:10 PM wrote:
> On 10/06/2010 09:24 AM, Nicholas A. Bellinger wrote:
>>> I like to hear the opinions of SCSI maintainer and ATA folks.
>>
>> jejb, jgarzik, tejun and co..?  Any thoughts here..?
> 
> I frankly have no idea whatsoever.  Is there something I can read to
> educate myself on the subject?

General information about a SCSI target subsystem you can find in
http://scst.sourceforge.net. More internal details about implementation
in http://scst.sourceforge.net/scst_pg.html. Features which are
implemented in http://scst.sourceforge.net/comparison.html.

Directly on the subject you can find some considerations in
http://lkml.org/lkml/2010/10/1/140 (second half of the message).

My opinion is that in ideal the SCSI initiator subsystem should be
drivers/scsi/initiator and the target subsystem - drivers/scsi/target
with shared code in drivers/scsi/. But in reality such big
reorganization is unlikely possible, so it's better to leave SCSI
initiator subsystem in drivers/scsi and the target subsystem - in the
separate directory in drivers/ (drivers/scst for SCST).

Vlad
