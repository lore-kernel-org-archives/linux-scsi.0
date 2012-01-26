From: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Subject: Re: [LSF/MM TOPIC] end-to-end data and metadata corruption detection
Date: Thu, 26 Jan 2012 17:27:56 +0100
Message-ID: <4F217F0C.6030105@itwm.fraunhofer.de>
References: <38C050B3-2AAD-4767-9A25-02C33627E427@oracle.com> <4F2147BA.6030607@itwm.fraunhofer.de> <yq1k44e1pn6.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <yq1k44e1pn6.fsf-+q57XtR/GgMb6DWv4sQWN6xOck334EZe@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sven Breuner <sven.breuner-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 01/26/2012 03:53 PM, Martin K. Petersen wrote:
>>>>>> "Bernd" == Bernd Schubert<bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>  writes:
>
> Bernd>  We from the Fraunhofer FhGFS team would like to also see the T10
> Bernd>  DIF/DIX API exposed to user space, so that we could make use of
> Bernd>  it for our FhGFS file system.  And I think this feature is not
> Bernd>  only useful for file systems, but in general, scientific
> Bernd>  applications, databases, etc also would benefit from insurance of
> Bernd>  data integrity.
>
> I'm attending a SNIA meeting today to discuss a (cross-OS) data
> integrity aware API. We'll see what comes out of that.
>
> With the Linux hat on I'm still mainly interested in pursuing the
> sys_dio interface Joel and I proposed last year. We have good experience
> with that I/O model and it suits applications that want to interact with
> the protection information well. libaio is also on my list.
>
> But obviously any help and input is appreciated...
>

I guess you are referring to the interface described here

http://www.spinics.net/lists/linux-mm/msg14512.html

Hmm, direct IO would mean we could not use the page cache. As we are 
using it, that would not really suit us. libaio then might be another 
option then.

What kind of help do you exactly need?


Thanks,
Bernd
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
