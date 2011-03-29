From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [Lsf] Preliminary Agenda and Activities for LSF
Date: Tue, 29 Mar 2011 07:16:32 -0400
Message-ID: <4D91BF90.8070909@redhat.com>
References: <1301373398.2590.20.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1301373398.2590.20.camel@mulgrave.site>
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: lsf@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 03/29/2011 12:36 AM, James Bottomley wrote:
> Hi All,
>
> Since LSF is less than a week away, the programme committee put together
> a just in time preliminary agenda for LSF.  As you can see there is
> still plenty of empty space, which you can make suggestions (to this
> list with appropriate general list cc's) for filling:
>
> https://spreadsheets.google.com/pub?hl=en&hl=en&key=0AiQMl7GcVa7OdFdNQzM5UDRXUnVEbHlYVmZUVHQ2amc&output=html
>
> If you don't make suggestions, the programme committee will feel
> empowered to make arbitrary assignments based on your topic and attendee
> email requests ...
>
> We're still not quite sure what rooms we will have at the Kabuki, but
> we'll add them to the spreadsheet when we know (they should be close to
> each other).
>
> The spreadsheet above also gives contact information for all the
> attendees and the programme committee.
>
> Yours,
>
> James Bottomley
> on behalf of LSF/MM Programme Committee
>

Here are a few topic ideas:

(1)  The first topic that might span IO & FS tracks (or just pull in device 
mapper people to an FS track) could be adding new commands that would allow 
users to grow/shrink/etc file systems in a generic way.  The thought I had was 
that we have a reasonable model that we could reuse for these new commands like 
mount and mount.fs or fsck and fsck.fs. With btrfs coming down the road, it 
could be nice to identify exactly what common operations users want to do and 
agree on how to implement them. Alasdair pointed out in the upstream thread that 
we had a prototype here in fsadm.

(2) Very high speed, low latency SSD devices and testing. Have we settled on the 
need for these devices to all have block level drivers? For S-ATA or SAS 
devices, are there known performance issues that require enhancements in 
somewhere in the stack?

(3) The union mount versus overlayfs debate - pros and cons. What each do well, 
what needs doing. Do we want/need both upstream? (Maybe this can get 10 minutes 
in Al's VFS session?)

Thanks!

Ric

