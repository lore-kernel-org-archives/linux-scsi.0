From: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Subject: Re: [LSF/MM TOPIC] end-to-end data and metadata corruption detection
Date: Thu, 26 Jan 2012 13:31:54 +0100
Message-ID: <4F2147BA.6030607@itwm.fraunhofer.de>
References: <38C050B3-2AAD-4767-9A25-02C33627E427@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <38C050B3-2AAD-4767-9A25-02C33627E427-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sven Breuner <sven.breuner-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 01/17/2012 09:15 PM, Chuck Lever wrote:
> Hi-
>
> I know there is some work on ext4 regarding metadata corruption
> detection; btrfs also has some corruption detection facilities.  The
> IETF NFS working group is considering the addition of corruption
> detection to the next NFSv4 minor version.  T10 has introduced
> DIF/DIX.
>
> I'm probably ignorant of the current state of implementation in
> Linux, but I'm interested in understanding common ground among local
> file systems, block storage, and network file systems.  Example
> questions include:  Do we need standardized APIs for block device
> corruption detection?  How much of T10 DIF/DIX should NFS support?
> What are the drivers for this feature (broad use cases)?
>

Other network file systems such as Lustre already use their own network 
data checksums. As far as I know Lustre plans (planned?) to use 
underlying ZFS checksums also for network transfers, so real 
client-to-disk (end-to-end) checksums. Using T10 DIF/DIX might be on 
their todo list.

We from the Fraunhofer FhGFS team would like to also see the T10 DIF/DIX 
API exposed to user space, so that we could make use of it for our FhGFS 
file system.
And I think this feature is not only useful for file systems, but in 
general, scientific applications, databases, etc also would benefit from 
insurance of data integrity.


Cheers,
Bernd


--
Bernd Schubert
Fraunhofer ITWM
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
