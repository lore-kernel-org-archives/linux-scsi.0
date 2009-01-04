From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
Subject: Re: [PATCH 2/4] fastboot: make scsi probes asynchronous
Date: Mon, 5 Jan 2009 00:08:42 +0530
Message-ID: <3f9a31f40901041038w47493205m9fcd87fe237ec257@mail.gmail.com>
References: <20090104092430.7ffd2c41@infradead.org>
	 <20090104092940.11943797@infradead.org>
	 <20090104180515.GD2002@parisc-linux.org>
	 <20090104101353.05e8df09@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090104101353.05e8df09@infradead.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu, fweisbec@gmail.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Jan 4, 2009 at 11:43 PM, Arjan van de Ven <arjan@infradead.org> wrote:
>
> just checked;
> my box has CONFIG_SCSI_SCAN_ASYNC=y set for both cases
> it seems to be about 0.1 seconds win still though...
> sounds little, but a kernel boot should be less than a second, so that
> is still 10%. And it's obviously also disk dependent..
> (I used libata connected disks obviously)
>

Do you also have boot time numbers for RAM and/or flash based
filesystem (disk-less)

JSR
