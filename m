From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] mpt3sas: Use driver scsi lookup to track outstanding IOs
Date: Tue, 19 Feb 2019 13:14:15 +0100
Message-ID: <20190219121415.GA23831@kroah.com>
References: <1550577766-40425-1-git-send-email-sreekanth.reddy@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1550577766-40425-1-git-send-email-sreekanth.reddy@broadcom.com>
Sender: stable-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 19, 2019 at 07:02:46AM -0500, Sreekanth Reddy wrote:
> Use driver's scsiio lookup table to track outstanding IOs at driver level,

And why is this a stable kernel patch?

You do not have a "Fixes:" tag in here.  It really looks like a new
feature :(

greg k-h
