From: jd <jpd_hp_linux_scsi@yahoo.com>
Subject: Re: 1st  REVIEW : UNH iSCSI for 2.6-test5
Date: Fri, 26 Sep 2003 04:17:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030926111759.33932.qmail@web60210.mail.yahoo.com>
References: <20030925091949.A6827@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web60210.mail.yahoo.com ([216.109.118.105]:28043 "HELO
	web60210.mail.yahoo.com") by vger.kernel.org with SMTP
	id S262056AbTIZLR7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2003 07:17:59 -0400
In-Reply-To: <20030925091949.A6827@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Thank you for feedback. 
I'll post follow ups shortly.

John Donnelly.

////
--- Christoph Hellwig <hch@infradead.org> wrote:
> More comments:
> 
>  - unh_iscsi/security should really go away.  We have a nice crypto
> API
>    in 2.6 and late 2.4, but authentification really shouldn't be done
>    in kernelspace anyway.
>  - kill iscsi_device.c.  A scsi LLDD has no business messing with
> device
>    nodes..
>  - you're comment style is strange.  In kernel code we tend to use
> 
> /*
>  * Foo, blah
>  * baz..
>  */
> 
> not
> 
> /*
> 
> */
> 
> but that's just a minor nitpick.
> 
> Having the module description over the copyright boilerplate also is
> very strange.
> 
>  - your split into common/ and initiator/ is strange.  You can build
>    multiple modules in one directory and that would cleanup your
>    includes mess nicely
>  - having a single host for all of iscsi looks strange.  Why do you
>    do that?
>  - the #ifdef K26 is totally unreadble.  Especially when it's around
>    code that works for both 2.4 and 2.6..
>  - kill my_kmallocd / my_free
>  - you seems to not handle lots of error returns, e.g. from
> down_interruptible
>    or kernel_thread
>  - the UNH_LOCK/UNH_UNLOCK obsfucation hinders reading
>  - kill ISCSI_INITIATOR, there's no need for this #define - just
> initialize
>    the host template directly
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


__________________________________
Do you Yahoo!?
The New Yahoo! Shopping - with improved product search
http://shopping.yahoo.com
