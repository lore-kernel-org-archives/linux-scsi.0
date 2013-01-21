From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH v13 1/9] scsi: sr: support runtime pm
Date: Mon, 21 Jan 2013 14:31:50 +1100
Message-ID: <CAGRGNgXMthaFSvj4aJ8KCZb2R70rvohh_kHPu2JY1tV_9veriQ@mail.gmail.com>
References: <50FA5F67.4080102@intel.com> <Pine.LNX.4.44L0.1301191312050.13032-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1301191312050.13032-100000@netrider.rowland.org>
Sender: linux-pm-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lu@intel.com>, Oliver Neukum <oneukum@suse.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Alan,

On Sun, Jan 20, 2013 at 5:46 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sat, 19 Jan 2013, Aaron Lu wrote:
>> > closed.  Do we want to drop support for that kind of behavior?
>>
>> I don't think we should drop such support.
>> And the safest way to avoid such break is we refine the suspend
>> condition for ODD, and using what ZPODD defined condition isn't that
>> bad to me:
>> - for tray type, no media inside and tray close;
>> - for slot type, no media inside.
>> While whether tray is closed or not may not be that important, but at
>> least we should make sure there is no media inside.
>>
>> Thoughts?
>
> That sounds reasonable to me, at least as a first step.  If people want
> their CD drive to suspend, they can eject the disc.

Stupid question: does the kernel know if a CD has audio tracks?

(I'm assuming that nobody will access a data track without mounting it
or holding the device open)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
