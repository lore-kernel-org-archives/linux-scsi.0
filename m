From: Dave Holland <dh3@sanger.ac.uk>
Subject: Re: RE: qla2xxx 0000:03:0c.0: Firmware image unavailable
Date: Thu, 22 Jan 2009 16:46:17 +0000
Message-ID: <20090122164616.GF19147@sanger.ac.uk>
References: <E463DF2B2E584B4A82673F53D62C2EF45CEAB550@cosmail01.lsi.com>
	<D4B83214B57CAC4499F1114D069E451A01A7D6FA@bunker.inside.abhaisystems.com>
	<E463DF2B2E584B4A82673F53D62C2EF45CEAB586@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF45CEAB586@cosmail01.lsi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 22, 2009 at 08:20:48AM -0700, Moger, Babu wrote:
> You are right. Looks like qlogic driver loads even before udev hotplug
> is functional.  Driver loads successfully when I re-load the driver
> after the system in up.  Is there any solution or work-around for this
> problem?

So the problem only happens at boot time? Are you using an initrd, and
if so, have you got the firmware images in the initrd image?
(mkinitramfs, update-initramfs, etc)

Dave
-- 
** Dave Holland ** Systems Support -- Infrastructure Management **
** 01223 496923 ** The Sanger Institute, Hinxton, Cambridge, UK **
"Your bumper is my crumple zone."


-- 
 The Wellcome Trust Sanger Institute is operated by Genome Research 
 Limited, a charity registered in England with number 1021457 and a 
 company registered in England with number 2742969, whose registered 
 office is 215 Euston Road, London, NW1 2BE. 
