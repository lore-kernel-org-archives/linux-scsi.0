From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 10/12] lkdtm: fix for CONFIG_SCSI=n
Date: Wed, 30 Jul 2008 15:16:48 -0500
Message-ID: <1217449008.3335.39.camel@localhost.localdomain>
References: <200807301944.m6UJiSab012906@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44856 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885AbYG3UQw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2008 16:16:52 -0400
In-Reply-To: <200807301944.m6UJiSab012906@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, randy.dunlap@oracle.com, ankita@in.ibm.com

On Wed, 2008-07-30 at 12:44 -0700, akpm@linux-foundation.org wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix lkdtm test code for case of CONFIG_SCSI=n, to avoid build errors:
> 
> In file included from linux-next-20080618/tests/lkdtm.c:55:
> linux-next-20080618/include/scsi/scsi_cmnd.h:28:25: warning: "BLK_MAX_CDB" is not defined
> linux-next-20080618/include/scsi/scsi_cmnd.h:29:3: error: #error MAX_COMMAND_SIZE can not be bigger than BLK_MAX_CDB
> In file included from linux-next-20080618/tests/lkdtm.c:55:
> linux-next-20080618/include/scsi/scsi_cmnd.h: In function 'scsi_bidi_cmnd':
> linux-next-20080618/include/scsi/scsi_cmnd.h:183: error: implicit declaration of function 'blk_bidi_rq'
> linux-next-20080618/include/scsi/scsi_cmnd.h:184: error: dereferencing pointer to incomplete type
> linux-next-20080618/include/scsi/scsi_cmnd.h: In function 'scsi_in':
> linux-next-20080618/include/scsi/scsi_cmnd.h:190: error: dereferencing pointer to incomplete type
> make[2]: *** [tests/lkdtm.o] Error 1
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Acked-by: Ankita Garg <ankita@in.ibm.com> 
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  tests/lkdtm.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff -puN tests/lkdtm.c~lkdtm-fix-for-config_scsi=n tests/lkdtm.c
> --- a/tests/lkdtm.c~lkdtm-fix-for-config_scsi=n
> +++ a/tests/lkdtm.c

OK, you've sent me this one twice now ... what exactly is it?  There's
no tests directory in any kernel tree I have.

James


