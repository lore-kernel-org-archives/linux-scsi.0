From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] scsi: introduce a quirk for false cache reporting
Date: Fri, 09 Sep 2016 07:26:17 -0400
Message-ID: <yq1zinhfh5y.fsf@sermon.lab.mkp.net>
References: <1471349112-13876-1-git-send-email-oneukum@suse.com>
        <yq1bn0pijqh.fsf@sermon.lab.mkp.net>
        <1473331428.32073.0.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473331428.32073.0.camel-IBi9RG/b67k@public.gmane.org> (Oliver Neukum's message of
        "Thu, 08 Sep 2016 12:43:48 +0200")
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org>
Cc: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org, mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, Johannes Thumshirn <JThumshirn-IBi9RG/b67k@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Oliver" == Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org> writes:

Oliver> On Thu, 2016-08-18 at 22:19 -0400, Martin K. Petersen wrote:
>> >>>>> "Oliver" == Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org> writes:
>> 
Oliver> Some SATA to USB bridges fail to cooperate with some drives
Oliver> resulting in no cache being present being reported to the
Oliver> host. That causes the host to skip sending a command to
Oliver> synchronize caches. That causes data loss when the drive is
Oliver> powered down.
>> 
>> Reviewed-by: Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> 

Oliver> may I ask about the fate of this patch? Has it been lost?
Oliver> Should I resubmit? Are any further changes necessary?

I'm OK with the change but it needs to go through the USB tree.

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
