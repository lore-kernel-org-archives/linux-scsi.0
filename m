From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 03/11] MPT: remove unused struct -- mpt_proc_entry_t
Date: Thu, 12 Feb 2009 21:30:11 +0300
Message-ID: <20090212183011.GA12809@x200.localdomain>
References: <200902112129.n1BLTWPO002251@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:40718 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176AbZBLSYA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Feb 2009 13:24:00 -0500
Received: by fg-out-1718.google.com with SMTP id 16so276407fgg.17
        for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2009 10:23:58 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <200902112129.n1BLTWPO002251@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com

On Wed, Feb 11, 2009 at 01:29:32PM -0800, akpm@linux-foundation.org wrote:
> --- a/drivers/message/fusion/mptbase.h~mpt-remove-unused-struct-mpt_proc_entry_t
> +++ a/drivers/message/fusion/mptbase.h
> @@ -402,17 +402,6 @@ typedef struct _VirtDevice {
>  #define MPT_TARGET_FLAGS_RAID_COMPONENT	0x40
>  #define MPT_TARGET_FLAGS_LED_ON		0x80
>  
> -/*
> - *	/proc/mpt interface
> - */
> -typedef struct {
> -	const char	*name;
> -	mode_t		 mode;
> -	int		 pad;
> -	read_proc_t	*read_proc;
> -	write_proc_t	*write_proc;
> -} mpt_proc_entry_t;

Andrew, please, just drop it.
I'll remove this code and much more during final conversion to seqfiles.
