From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: Inhibit auto-attach of scsi disks ?
Date: Wed, 2 Oct 2002 23:56:30 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021002235630.C12192@bitwizard.nl>
References: <OF4F84AA07.A8C2EDB0-ON87256C46.0062DDBA@boulder.ibm.com> <1033588299.23661.34.camel@irongate.swansea.linux.org.uk> <20021002233045.A12192@bitwizard.nl> <20021002214440.GA30503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021002214440.GA30503@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Bryan Henderson <hbryan@us.ibm.com>, Scott Merritt <Scsi@PragmaSoft.com>, linux-scsi@vger.kernel.org

On Wed, Oct 02, 2002 at 05:44:40PM -0400, Doug Ledford wrote:
> example catch the first attempt to open any partition on a device and if 
> we haven't read the partition table yet then do so and then determine if 
> the open succeeds, something like that).

FYI, I think I saw the kernel doing this already today, albeit, not 
completely correct: It only scanned for partitions once I opened  
/dev/sda, for which knowing the partition table is irrelevant. 
usb-storage.

				Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
*-- BitWizard writes Linux device drivers for any device you may have! --*
* The Worlds Ecosystem is a stable system. Stable systems may experience *
* excursions from the stable situation. We are currenly in such an       * 
* excursion: The stable situation does not include humans. ***************
