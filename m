Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190856;
	b=Lf43hfICvuFbNNN+CjzWpBVdoLGExtdWL23UlaDQil2STlNWtSCKRaAB7KsftwRAh0rE
	 J0ezpjVm6hz5r7S5SEPlGzIatHPjO1mdsThbeAEkwhOqIgCDIytpk3PKW0ceo1pb7eF26
	 k/O5tl2Tbgz9bREUK2CKpAQUtueoO2zV+qxJmR4sNgqCJ0BbpM5LiaKmikDw8x1rA4D2c
	 SuHnTJ93JBCenyGuYK9ifNssblePfnFyDXIBqwa2e4QIVK61ykBCd34s7OHn4UXQ/yVsd
	 c5pykdMHMzHjANjZJK8FGeQXZx7hea+nsIXHQ3PoZ82lop+A1A7/hI1beqsOPDWf3cQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190856;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=betQ2CoEQ/mBmZNfTxapq11hedAnmhh1frpMEbB1xZY=;
	b=OCyT2We/Ew96nFcwvRwPQOztRRwbC7OHsweu/EThLmSwyMqBiqWYres+Eu01xzeX9VGd
	 buAz42QCPzHXV1BPSt40Ep2rP/39anyFEZYp9j3yoYVhhO6/BMZjvVQzW5BBiVzKQ1Q9Y
	 fVzpNyomMSOwyko4z9giYb4wDTBQFOg+FF5j+vCKDZXbDqQtNNN32FXr4DWAtsRa49BU1
	 seAz8uZ+ZGIgJjVaBQbkl3u8Lrd7O9c/6NdS9UmtK02JFhjakyBwSMsf1HKDdEIKgkP/y
	 9WmRUWwOVIb1nS+emWt+wtgI56EPs079urbx+Jfb6+aWJBkkaO6g2t7wKh3fXCdmkiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=af8gBn6d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65CF606A31A;
	Wed, 28 Oct 2026 12:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=af8gBn6d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004FD1F01825;
	Wed, 28 Oct 2026 12:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793190855;
	bh=betQ2CoEQ/mBmZNfTxapq11hedAnmhh1frpMEbB1xZY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=af8gBn6dFchbs70jdQYN3ScFsFE48pvmYh5ExZgr8NPOeyulWvOSXftgiVPUtyf5j
	 u18AIzOJVSvz2vMQQSeVPfy6todqN74e95mTlh2Fgb5UOMIXj0bBnwfyV7sPtNdYU2
	 gib49mc+ZNMMMTJ0H6atxziu+IO/Vk/2ImYDaJ3asExVtzrSvjSQlzpNHl6ByPaC8a
	 oYsF8fyRKGbw+plaoy9kD46pu0gyTj4kjzmHIAiwk4CndH+1xxErBlcp+RHbK9Wbtm
	 MkLeDnPBGMqnUGSdK4d3rRsGKRXQXlCWlyqG2H/s2NwHDdF/irIrlMXbiP7ND32K72
	 FyDRURlGqH6NA==
From: Lee Jones <lee@kernel.org>
To: linux-leds@vger.kernel.org, Liang Haowen <nbg2974@gmail.com>
Cc: lee@kernel.org, pavel@kernel.org, mkp@kernel.org, 
 linux-scsi@vger.kernel.org, platform-driver-x86@vger.kernel.org, 
 linux-kernel@vger.kernel.org, denis.benato@linux.dev, W_Armin@gmx.de, 
 hansg@kernel.org, ilpo.jarvinen@linux.intel.com, scardracs@disroot.org
In-Reply-To: <20261015140051.1159817-2-nbg2974@gmail.com>
References: <20261015140051.1159817-2-nbg2974@gmail.com>
Subject: Re: (subset) [RFC v10 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB
 LED driver for ROG NVMe enclosures
Message-Id: <179319085271.3664457.8130606663267466619.b4-ty@b4>
Date: Wed, 28 Oct 2026 12:34:12 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.16-dev-ad80c

On Thu, 15 Oct 2026 22:00:51 +0800, Liang Haowen wrote:
> ASUS ROG external NVMe enclosures (ROG STRIX Arion, USB 0b05:1932) are
> plain USB mass-storage devices with no HID interface: the Aura LEDs
> hang off an ENE controller driven by vendor SCSI commands on the same
> LUN as the disk. The enclosure has 4 independently addressable LEDs,
> verified on hardware.
> 
> Register a scsi_device_handler matched by INQUIRY (vendor "ROG",
> model "ESD-S1C"); it does not claim the sdev (sd keeps owning the
> disk) and exposes each LED as a multicolor LED class device,
> /sys/class/leds/asus-arion-0-0-0-0::led-0 through led-3. The
> H:C:T:L part of the sdev name keeps the names unique when more than
> one enclosure is connected, with its colons flattened to dashes. The
> color section stays empty, since multicolor LEDs enumerate their
> palette via multi_intensity, and the four identical zones use the
> function name with a "-N" ordinal, as the naming section in
> Documentation/leds/leds-class.rst asks for.
> 
> [...]

Applied, thanks!

[1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG NVMe enclosures
      commit: e3ea86f2c378b5ba6355712f09566eec44eb16bf

--
Lee Jones [李琼斯]

