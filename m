From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Using get_last_written() in sr.c causes problems with some usb
 devices (bz.kernel.org 9668)
Date: Tue, 27 Apr 2010 12:35:29 +0200
Message-ID: <4BD6BDF1.7070407@redhat.com>
References: <4BD6B1B3.30707@redhat.com> <4BD6B37E.2060205@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BD6B37E.2060205-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

On 04/27/2010 11:50 AM, Tejun Heo wrote:
> Hello,
>
> On 04/27/2010 11:43 AM, Hans de Goede wrote:
>> The only thing I can come up with to fix this is a device specific
>> quirk. Either in sr.c or in ubs-storage. Which is not a very
>> pretty solution, hence this mail in the hope someone has
>> a clever idea.
>
> For cases like this, I think quirking is the cleanest solution.
> Trying to modify generic behavior to accomodate special cases
> sometimes create unexpected subtle issues in other devices and as the
> fix itself is buried in the general seemingly unrelated logic, it's
> relatively easy to lose the workaround later during an unrelated
> update.
>
> Is the device uniquely identifiable?
>

Yes it can be uniquely identified from its USB-ID, which
using a usb-storage unusual devs entry for this with a new flag
is the best solution.

Regards,

Hans
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
