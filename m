From: Andrew Morton <akpm@osdl.org>
Subject: Re: OOps in 2.6.0-test4-mm3-1
Date: Sat, 30 Aug 2003 16:36:53 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030830163653.6ac5464f.akpm@osdl.org>
References: <20030828235649.61074690.akpm@osdl.org>
	<20030830014309.GA898@matchmail.com>
	<20030829200926.3e2b7eb6.akpm@osdl.org>
	<20030830232003.GB898@matchmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20030830232003.GB898@matchmail.com>
To: Mike Fedyk <mfedyk@matchmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Mike Fedyk <mfedyk@matchmail.com> wrote:
>
> Though, is there any reason why
>  2.6.0-test2-mm1 doesn't oops too? 

Of course.  drivers/scsi/hosts.c was changed and it broke.
