From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] use mmiowb in qla1280.c
Date: Mon, 25 Oct 2004 12:02:23 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20041025120223.3633ea4c.akpm@osdl.org>
References: <200410211613.19601.jbarnes@engr.sgi.com>
	<200410211617.14809.jbarnes@engr.sgi.com>
	<1098634812.10906.38.camel@mulgrave>
	<200410250918.01786.jbarnes@engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261251AbUJYTLp@vger.kernel.org>
In-Reply-To: <200410250918.01786.jbarnes@engr.sgi.com>
To: Jesse Barnes <jbarnes@engr.sgi.com>
Cc: James.Bottomley@steeleye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jeremy@sgi.com, jes@sgi.com
List-Id: linux-scsi@vger.kernel.org

Jesse Barnes <jbarnes@engr.sgi.com> wrote:
>
> > *** Warning: "mmiowb" [drivers/scsi/qla1280.ko] undefined!
> 
>  Only works in Andrew's tree until he pushes mmiowb to Linus.

I haven't been following this stuff at all closely and I need help
determining which patches should be pushed, and when.  Please.
