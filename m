From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Do we need to implement sr START/STOP management
Date: Tue, 01 Nov 2011 09:53:32 +0400
Message-ID: <1320126812.7701.17.camel@dabdike>
References: <CADyp2PebObcVyMAA=XzTayiXmBxYRJtR3xY6b3tJYiVA=hCaqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CADyp2PebObcVyMAA=XzTayiXmBxYRJtR3xY6b3tJYiVA=hCaqQ@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: JiSheng Zhang <jszhang3@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-11-01 at 13:31 +0800, JiSheng Zhang wrote:
> Currently, there's no start/stop management in scsi cdrom driver to
> spin up/down the motor do we need to implement it?

Say more ... like what you think it buys.  The auto spin down of a CD
tends to be the best power control we have and it's not even clear that
manufacturers have implemented any other useful power states.

James


