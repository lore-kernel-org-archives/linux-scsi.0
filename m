From: Zwane Mwaikambo <zwane@linuxpower.ca>
Subject: Re: 2.5.63/64 do not boot: loop in scsi_error
Date: Thu, 6 Mar 2003 04:58:47 -0500 (EST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.50.0303060455560.25282-100000@montezuma.mastecende.com>
References: <UTC200303060639.h266dIo22884.aeb@smtp.cwi.nl>
 <20030306064921.GA1425@beaverton.ibm.com>
 <Pine.LNX.4.50.0303060256200.25282-100000@montezuma.mastecende.com>
 <20030306083054.GB1503@beaverton.ibm.com>
 <Pine.LNX.4.50.0303060331030.25282-100000@montezuma.mastecende.com>
 <20030306085506.GB2222@beaverton.ibm.com>
 <Pine.LNX.4.50.0303060354550.25282-100000@montezuma.mastecende.com>
 <20030306091824.GA2577@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20030306091824.GA2577@beaverton.ibm.com>
To: Mike Anderson <andmike@us.ibm.com>
Cc: Andries.Brouwer@cwi.nl, torvalds@transmeta.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 6 Mar 2003, Mike Anderson wrote:

> Would it be possible for you to send me a console output with
> scsi_logging=1 so that I can narrow down the failure case.

The following is from 2.5.63-mjb2

http://function.linuxpower.ca/patches/numaq/dmesg-scsi_logging

The [disconnect] point is where it locks up

	Zwane
-- 
function.linuxpower.ca
