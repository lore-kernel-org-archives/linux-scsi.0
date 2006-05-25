From: Kearnan_Keith@emc.com
Subject: RE: resizing LUN (not file system) while the file system (ext3) i
	sonline
Date: Thu, 25 May 2006 09:11:34 -0400
Message-ID: <4A8F680AC6EC43458BCAE06010D8E81B02841D4B@CORPUSMX40A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([168.159.213.200]:51499 "EHLO
	mexforward.lss.emc.com") by vger.kernel.org with ESMTP
	id S965166AbWEYNLy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 May 2006 09:11:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: admitriev@mentora.com, lance.lmwang@gmail.com, sct@redhat.com


Hi folks,

Since I am the author of the EMC knowledge base article (emc122304)
mentioned I feel I should respond to this thread.


Andrey,

You are correct.  Overcautious is exactly what I was shooting for...so it
worked.  Remember, complete newbies (Windows Admins that get Linux added to
their responsibility) read these knowledge base articles and then try them
out on their company's vital data.  


Limin,

LVM can be done online by adding an additional PV.  I've had a customer
expand their single PV "behind the scenes".  Is there a way to get LVM to
recognize a resized PV?  If so please share because I couldn't find a
command to do it.


Stephen,

The article is dated 11/18/2005 and states "ext3 does not support online
expansion...yet".  So yes it is very out of date.

I will get to work updating emc122304.  Did this behavior start in base
RHEL4 (2.6.9-5)?  
   

Cheers,

-Keith

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Stephen C. Tweedie
Sent: Thursday, May 25, 2006 7:46 AM
To: admitriev@mentora.com
Cc: linux-scsi@vger.kernel.org; Stephen Tweedie
Subject: Re: resizing LUN (not file system) while the file system (ext3)
isonline

Hi,

On Thu, 2006-05-25 at 01:16 -0400, Andrey Dmitriev wrote:

> I understand that ext3 doesn't support online expansion (not in RedHat
ES/AS
> at least)

Yes it does, and it should work fine in RHEL-4, or FC-3 or later.  Ted
just integrated the online resize user-space tools into upstream
e2fsprogs a couple of months ago, and only this week he turned on the
resize inode feature in mke2fs by default.

> However, just because the disk array can be done online that does not mean
> the application layer can handle online expansion (some file systems can
> handle online expansion, currently ext3 cannot)."

Out-of-date information. :-)

Cheers,
 Stephen


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
