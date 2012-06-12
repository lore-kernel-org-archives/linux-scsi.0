From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: allow persistent reservations without
 CAP_SYS_RAWIO
Date: Tue, 12 Jun 2012 17:21:09 +0100
Message-ID: <1339518069.3050.8.camel@dabdike.int.hansenpartnership.com>
References: <1339517312-18134-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1339517312-18134-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-06-12 at 18:08 +0200, Paolo Bonzini wrote:
> Persistent reservations commands cannot be issued right now without
> giving CAP_SYS_RAWIO to the process who wishes to send them.  This
> is a bit heavy-handed, allow these two commands.

Why is this heavy handed?  If you remove CAP_SYS_RAWIO, any userspace
process can send these, which would allow any user to completely disrupt
a SAN by injecting spurious reservations ... that doesn't look to be
terribly safe for an operating system running in a data centre.

James
 
