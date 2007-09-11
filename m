From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [PATCH ver3 1/5] scsi_error: code cleanup before refactoring
 of scsi_send_eh_cmnd()
Date: Tue, 11 Sep 2007 11:54:45 +0300
Message-ID: <46E657D5.2080108@panasas.com>
References: <46E59760.9020705@panasas.com> <46E59C3E.1020703@panasas.com>	 <46E64BDE.2070602@panasas.com> <646765f40709110111w5a6a2913n9c7080f13206c366@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:22352 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932517AbXIKIzX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 04:55:23 -0400
In-Reply-To: <646765f40709110111w5a6a2913n9c7080f13206c366@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@steeleye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@suse.de>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, Randy Dunlap <rdunlap@xenotime.net>

On Sep 11, 2007, 11:11 +0300, "Julian Calaby" <julian.calaby@gmail.com> wrote:
> (added CCs - that's what you get for sending emails after 5.)
> 
> On 9/11/07, Boaz Harrosh <bharrosh@panasas.com> wrote:
>>  static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
>> -                            int cmnd_size, int timeout, int copy_sense)
>> +                            int cmnd_size, int timeout, unsigned sense_bytes)
> 
> Shouldn't that be unsigned _int_?

It could but first, "unsigned" and "unsigned int" are the same type
and second, this is consistent with *bufflen type which is "unsigned" all over
the place.

Benny

> 
> Thanks,
> 
> --
> 
> Julian Calaby
> 
> Email: julian.calaby@gmail.com
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

