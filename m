From: Alan Cox <alan@redhat.com>
Subject: Re: PATCH: Further aacraid work
Date: Tue, 29 Jun 2004 14:37:32 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040629183732.GA3243@devserv.devel.redhat.com>
References: <20040616210455.GA13385@devserv.devel.redhat.com> <Pine.LNX.4.60.0406291344195.26319@winds.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org-S265898AbUF2SiA@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0406291344195.26319@winds.org>
To: Byron Stanoszek <gandalf@winds.org>
Cc: Alan Cox <alan@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 29, 2004 at 01:48:39PM -0400, Byron Stanoszek wrote:
> Linux version 2.6.7 (gcc version 3.4.0) #3 SMP Tue Jun 29 13:23:58 EDT 2004

Never tested with gcc 3.4 but that ought no to matter. The normal cause
for that kind of error is the firmware stopping responding. Make sure
you have current firmware updates as a starting point
