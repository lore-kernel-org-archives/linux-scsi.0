From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Pb between an UltraTrak SX8000 and an Adaptec 29160
Date: 20 Nov 2002 16:08:51 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1037808531.3267.33.camel@irongate.swansea.linux.org.uk>
References: <000501c28f02$934b3000$13e2cf82@darkwolf>
	<1037626683.7486.10.camel@irongate.swansea.linux.org.uk>
	<3DDBA8A8.F370532E@lipsyncpost.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3DDBA8A8.F370532E@lipsyncpost.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Simon Burley <simonb@lipsyncpost.co.uk>
Cc: didier@ece.gatech.edu, "'Justin T. Gibbs'" <gibbs@scsiguy.com>, linux-scsi@vger.kernel.org

On Wed, 2002-11-20 at 15:22, Simon Burley wrote:
> Can I ask what the symptoms of this failure to support >1Tb volumes
> would be? Failure to identify the device? Random read/write failures?
> Completely corrupted disk? It's the first time I've heard this!

There is a fundamental 2Gb minus a bit limit (2^32 sectors). One or two
bits of the kernel (LVM1 I believe is one) use signed maths here and
there. So 1-2Gb generally works but its not something to guarantee.

2.5.x supports wy more


