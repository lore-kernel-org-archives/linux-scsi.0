From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] support for bidirectional transfers and variable length
 CDBs
Date: Mon, 30 Oct 2006 07:55:25 -0500
Message-ID: <4545F63D.7080504@emulex.com>
References: <4541F822.70700@panasas.com> <20061028163609.GA17317@infradead.org> <4544ADB3.8050708@panasas.com> <20061029134852.GB22902@infradead.org>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51110 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932429AbWJ3M4g
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Oct 2006 07:56:36 -0500
In-Reply-To: <20061029134852.GB22902@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Benny Halevy <bhalevy@panasas.com>, linux-scsi@vger.kernel.org, Mike Christie <mchristi@redhat.com>, James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, Dalit Naor <DALIT@il.ibm.com>, Liran Schour <LIRANS@il.ibm.com>, Sami.Iren@seagate.com, Daniel.E.Messinger@seagate.com, stuart.brodsky@seagate.com, open-iscsi@googlegroups.com, Boaz Harrosh <bharrosh@panasas.com>

Christoph Hellwig wrote:
>>> - you submit your patch that fixes the scsi_execute comment typo
>>> - you submit your patch to add the VARLEN_CDB opcode
>>> - you start converting as many as possible drivers to the
>>>   above wrapper API (I already had a big FC card vendor signed up
>>>   for this, but no updates so far..)

Sign me (Emulex) up for the last item - and if you send me pre-releases
of your patches, we can help out with preliminary testing.

-- james s
