From: Scott Merritt <Scsi@PragmaSoft.com>
Subject: Re: Inhibit auto-attach of scsi disks ?
Date: Wed, 2 Oct 2002 16:52:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021002165217.7d2a2ef3.Scsi@PragmaSoft.com>
References: <OF4F84AA07.A8C2EDB0-ON87256C46.0062DDBA@boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <OF4F84AA07.A8C2EDB0-ON87256C46.0062DDBA@boulder.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2 Oct 2002 11:10:20 -0700
"Bryan Henderson" <hbryan@us.ibm.com> wrote:
 
> I agree that Linux would be cleaner if auto-attach were optional ...

> But when we speak of inhibiting partition table reading, I think that's
> another (missing) feature:  I should be able to control whether Linux
> considers there to be partitions on my disk or not ...

Can you envision an "elegant" way in which these preferences could be communicated to the scsi disk drivers ? - including the case where you have only a scsi disk as root ?  Perhaps a kernel command line option together with some type of "noauto" option in /etc/fstab ???  There's probably a much better place, but I'm not "clever" enough to come up with it ... :)

Best regards, Scott.
