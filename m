From: George Cherian <gcherian-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Subject: Re: JMS56x not working reliably with uas driver
Date: Thu, 22 Dec 2016 07:34:44 +0530
Message-ID: <98b66992-826f-7073-2a1d-eee6a2a9590f@caviumnetworks.com>
References: <585A69E6.6040009@caviumnetworks.com>
 <1482320547.7638.7.camel@suse.com> <585A7073.3060904@caviumnetworks.com>
 <931b00cf-e273-6d07-8a99-71916376af67@redhat.com>
 <585A79F5.7080701@caviumnetworks.com> <1482331185.7638.14.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482331185.7638.14.camel-IBi9RG/b67k@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org>
Cc: George.Cherian-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi Oliver,

I will try it out and update you!!


Regards,

-George

On Wednesday 21 December 2016 08:09 PM, Oliver Neukum wrote:
> On Wed, 2016-12-21 at 18:17 +0530, George Cherian wrote:
>> [  843.149653] scsi host5: uas_post_reset: alloc streams error -19
>> after
>> reset
> That would mean the endpoints are gone. Which is odd.
>
>> [  843.157268] sd 5:0:0:0: [sdb] Synchronizing SCSI cache
> Could you try the attached patch and do a SCSI log of the enumeration?
>
> 	Regards
> 		Oliver
>

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
