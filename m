From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: RE: [PATCH] mpt3sas: Use driver scsi lookup to track outstanding IOs
Date: Tue, 19 Feb 2019 19:14:17 +0530
Message-ID: <159855771db2192a00c3c248f0e3cab9@mail.gmail.com>
References: <1550577766-40425-1-git-send-email-sreekanth.reddy@broadcom.com> <20190219121415.GA23831@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190219121415.GA23831@kroah.com>
Sender: stable-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-scsi@vger.kernel.org, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Greg,

This patch will fix the issue discussed in below email thread,
https://patchwork.kernel.org/patch/10734933/

Yesterday same issue is been reported by Michal Soltys in below thread,
https://marc.info/?l=linux-scsi&m=155057830803859&w=2

Thanks,
Sreekanth

-----Original Message-----
From: Greg KH [mailto:gregkh@linuxfoundation.org]
Sent: Tuesday, February 19, 2019 5:44 PM
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: linux-scsi@vger.kernel.org; Sathya.Prakash@broadcom.com;
suganath-prabu.subramani@broadcom.com; stable@vger.kernel.org
Subject: Re: [PATCH] mpt3sas: Use driver scsi lookup to track outstanding
IOs

On Tue, Feb 19, 2019 at 07:02:46AM -0500, Sreekanth Reddy wrote:
> Use driver's scsiio lookup table to track outstanding IOs at driver
> level,

And why is this a stable kernel patch?

You do not have a "Fixes:" tag in here.  It really looks like a new
feature :(

greg k-h
