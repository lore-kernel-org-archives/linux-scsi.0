From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [v6 3/4] mpt3sas:Fix driver modifying persistent data.
Date: Tue, 30 Oct 2018 08:34:42 -0500
Message-ID: <20181030133442.GC41022@google.com>
References: <1540290081-15827-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1540290081-15827-4-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1540290081-15827-4-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Cc: lukas@wunner.de, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, benh@kernel.crashing.org, ruscur@russell.cc, sbobroff@linux.ibm.com, oohall@gmail.com, andy.shevchenko@gmail.com, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 23, 2018 at 03:51:20PM +0530, Suganath Prabu wrote:
> * If EEDPTagMode field in manufacturing page11 is set,
> unset it. This is needed to fix a hardware bug
> in SAS3/SAS2 cards, So, skipping EEDPTagMode changes
> in Manufacturing page11 for SAS35 controllers.
> 
> * Fix driver modifying NVRAM/persistent data in
> Manufacturing page11 along with current copy. Driver should
> change only current copy of Manufacturing page11.

These *look* like two separate changes that should be in separate patches.

Also, fix your subject line so "git log --oneline drivers/scsi/mpt3sas"
looks nice  This subject line is missing a space in "mpt3sas:Fix"

Bjorn
