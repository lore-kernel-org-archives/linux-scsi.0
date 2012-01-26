From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [LSF/MM TOPIC] end-to-end data and metadata corruption detection
Date: Thu, 26 Jan 2012 09:53:33 -0500
Message-ID: <yq1k44e1pn6.fsf@sermon.lab.mkp.net>
References: <38C050B3-2AAD-4767-9A25-02C33627E427@oracle.com>
	<4F2147BA.6030607@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F2147BA.6030607-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org> (Bernd Schubert's message
	of "Thu, 26 Jan 2012 13:31:54 +0100")
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sven Breuner <sven.breuner-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Bernd" == Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org> writes:

Bernd> We from the Fraunhofer FhGFS team would like to also see the T10
Bernd> DIF/DIX API exposed to user space, so that we could make use of
Bernd> it for our FhGFS file system.  And I think this feature is not
Bernd> only useful for file systems, but in general, scientific
Bernd> applications, databases, etc also would benefit from insurance of
Bernd> data integrity.

I'm attending a SNIA meeting today to discuss a (cross-OS) data
integrity aware API. We'll see what comes out of that.

With the Linux hat on I'm still mainly interested in pursuing the
sys_dio interface Joel and I proposed last year. We have good experience
with that I/O model and it suits applications that want to interact with
the protection information well. libaio is also on my list.

But obviously any help and input is appreciated...

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
