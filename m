From: Tony Luck <tony.luck@gmail.com>
Subject: Re: scsi scan: INQUIRY result too short (5), using 36
Date: Wed, 24 Jul 2013 12:02:21 -0700
Message-ID: <CA+8MBbJUi9Xy1mMivQo=gbk_SRNJ3fzs+mw+hXY+ovVQPXORPA@mail.gmail.com>
References: <CA+8MBb+pSmRPqV-5xsEwBM_23sGaci5T6vka1LgTD5aiEoHCbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+8MBb+pSmRPqV-5xsEwBM_23sGaci5T6vka1LgTD5aiEoHCbg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Oops ... forgot final step.  That commit does revert cleanly (at least
git did not grumble when I asked it to revert).  The resulting kernel
builds cleanly and boots without seeing this problem.

-Tony
