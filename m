From: "Julian Calaby" <julian.calaby@gmail.com>
Subject: Re: [PATCH ver3 1/5] scsi_error: code cleanup before refactoring of scsi_send_eh_cmnd()
Date: Tue, 11 Sep 2007 18:11:44 +1000
Message-ID: <646765f40709110111w5a6a2913n9c7080f13206c366@mail.gmail.com>
References: <46E59760.9020705@panasas.com> <46E59C3E.1020703@panasas.com>
	 <46E64BDE.2070602@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.233]:10932 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759444AbXIKILp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 04:11:45 -0400
Received: by nz-out-0506.google.com with SMTP id s18so668163nze
        for <linux-scsi@vger.kernel.org>; Tue, 11 Sep 2007 01:11:45 -0700 (PDT)
In-Reply-To: <46E64BDE.2070602@panasas.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@suse.de>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, Randy Dunlap <rdunlap@xenotime.net>

(added CCs - that's what you get for sending emails after 5.)

On 9/11/07, Boaz Harrosh <bharrosh@panasas.com> wrote:
>
>  static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
> -                            int cmnd_size, int timeout, int copy_sense)
> +                            int cmnd_size, int timeout, unsigned sense_bytes)

Shouldn't that be unsigned _int_?

Thanks,

--

Julian Calaby

Email: julian.calaby@gmail.com
