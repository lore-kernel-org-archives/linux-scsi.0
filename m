From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] md: bitwise operations might not fit in a "bool"
Date: Tue, 27 Jul 2010 15:27:58 -0700
Message-ID: <4C4F5D6E.10201@zytor.com>
References: <4C47ED7B.1050709@gmail.com>	<20100722173716.66264bef@notabene>	<4C481FD5.4070509@gmail.com>	<4C482F35.6000004@panasas.com> <20100722215555.7ab2b1ee@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:34375 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab0G0W2v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jul 2010 18:28:51 -0400
In-Reply-To: <20100722215555.7ab2b1ee@notabene>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Christoph Hellwig <hch@infradead.org>, Jiri Slaby <jirislaby@gmail.com>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, hch@lst.de, jaxboe@fusionio.com, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org

>> -	const bool do_sync = (bio->bi_rw & REQ_SYNC);
>> +	const bool do_sync = (bio->bi_rw & REQ_SYNC) != 0;

FWIW, this is a null change.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

