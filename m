From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Lsf] Preliminary Agenda and Activities for LSF
Date: Tue, 29 Mar 2011 12:47:02 -0700
Message-ID: <1301428022.6814.74.camel@haakon2.linux-iscsi.org>
References: <1301373398.2590.20.camel@mulgrave.site>
	 <4D91BF90.8070909@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4D91BF90.8070909@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, lsf@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-03-29 at 07:16 -0400, Ric Wheeler wrote:
> On 03/29/2011 12:36 AM, James Bottomley wrote:
> > Hi All,
> >
> > Since LSF is less than a week away, the programme committee put together
> > a just in time preliminary agenda for LSF.  As you can see there is
> > still plenty of empty space, which you can make suggestions (to this
> > list with appropriate general list cc's) for filling:
> >
> > https://spreadsheets.google.com/pub?hl=en&hl=en&key=0AiQMl7GcVa7OdFdNQzM5UDRXUnVEbHlYVmZUVHQ2amc&output=html
> >
> > If you don't make suggestions, the programme committee will feel
> > empowered to make arbitrary assignments based on your topic and attendee
> > email requests ...
> >
> > We're still not quite sure what rooms we will have at the Kabuki, but
> > we'll add them to the spreadsheet when we know (they should be close to
> > each other).
> >
> > The spreadsheet above also gives contact information for all the
> > attendees and the programme committee.
> >
> > Yours,
> >
> > James Bottomley
> > on behalf of LSF/MM Programme Committee
> >
> 
> Here are a few topic ideas:
> 
> (1)  The first topic that might span IO & FS tracks (or just pull in device 
> mapper people to an FS track) could be adding new commands that would allow 
> users to grow/shrink/etc file systems in a generic way.  The thought I had was 
> that we have a reasonable model that we could reuse for these new commands like 
> mount and mount.fs or fsck and fsck.fs. With btrfs coming down the road, it 
> could be nice to identify exactly what common operations users want to do and 
> agree on how to implement them. Alasdair pointed out in the upstream thread that 
> we had a prototype here in fsadm.
> 
> (2) Very high speed, low latency SSD devices and testing. Have we settled on the 
> need for these devices to all have block level drivers? For S-ATA or SAS 
> devices, are there known performance issues that require enhancements in 
> somewhere in the stack?
> 
> (3) The union mount versus overlayfs debate - pros and cons. What each do well, 
> what needs doing. Do we want/need both upstream? (Maybe this can get 10 minutes 
> in Al's VFS session?)
> 

Hi Ric, James and LSF-PC chairs,

Beyond my original LSF topic proposal for the next-generation QEMU/KVM
Virtio-SCSI target driver here:

http://marc.info/?l=linux-scsi&m=129706545408966&w=2

The following target mode related topics would be useful for the current
attendees with interest in /drivers/target/ code if there is extra room
available for local attendance within the IO/storage track.

(4) Enabling mixed Target/Initiator mode in existing mainline SCSI LLDs
that support HW target mode, and come to an consensus determination for
how best to make the SCSI LLD / target fabric driver split when enabling
mainline target infrastructure support into existing SCSI LLDs.  This
code is currently in flight for qla2xxx / tcm_qla2xxx for .40  (Hannes,
Christoph, Mike, Qlogic and other LLD maintainers)

(5) Driving target configfs group creation from kernel-space via a
userspace passthrough using some form of portable / acceptable mainline
interface.  This is a topic that has been raised on the scsi list for
the ibmvscsis target driver for .40, and is going to be useful for other
in-flight HW target driver as well. (Tomo-san, Hannes, Mike, James,
Joel)

Thank you!

--nab

