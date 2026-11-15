Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.222.135.158
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794767206;
	b=W3SaODQ8CO94smdjUF2/62yFu8smhJSrJAqgEM95wrnCZC7hk4Ekw4JmrN6fu0xJMfy8
	 r1pj6tPuP4FZsSihXOe4rexMThusxJI92TgaYSb+CjzR5/muTPsNSW+EvQ0eLSvD1FuCr
	 0cQTkIaSGpeTkMdvfa/BZGwXGxvRJ7MJOOshWAgYAxecShVfi05K9/CCA7yy6ZjASOm9Q
	 dwXSkDgY/bVEmMLIo3VTBRO350K6rXJXjPRVsHnYB+owJvUR43VsEKUDl0Wyz+GQaryvM
	 hOZwnRYD++L5lJ3K7TPwUUovTD9DjkOA9/pYVfcVkGlPjT9Z/LPfDaUge677DZJqzLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794767206;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-WP-MailID:X-WP-AV:X-WP-SPAM;
	bh=d6Mw+ubXF8sNdhhSz6FQxX5iaQzd+/Pf5yiAG6Xqtuo=;
	b=DEyHh5Nm5cO4mAmM5ogaE0N4JXgIk/PNraaEMHvcv/cnlSKB4Ca/nhji9c+2o/SfgLtG
	 qmprXC2+he3PQJUn/2AEi0+B8aiHwMV6LSAIcsq+6bR3KUZtfQnOamwpBux5ZF/nQRqoD
	 chsG/1waW3TsslWUwvqz/VMLdjKw4Ph8Cv2nR6kyPs1Z7sAGOPYIv87odVDYIA3g2SttS
	 jyHADo17zIJMQhmz51nduaTiunq/iH2nCTWhM99R5rsfdkEsOlGmmQNeXV9qSvSTlqBU5
	 IQ5S+trxfsckX0oeCG/uCyTCyT5Bu43gPioskKJW/mCnkTNShVUuFAQ2uouaXkVH4kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=o2.pl;
	spf=pass smtp.mailfrom=o2.pl;
	dkim=pass header.d=o2.pl header.i=@o2.pl header.a=rsa-sha256 header.s=s20261001 header.b=AWKwe+4m;
	arc=none smtp.remote-ip=193.222.135.158
Received: from mx-out.tlen.pl (mx-out.tlen.pl [193.222.135.158])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79FC606A329
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 18:26:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A79FC606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=o2.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=o2.pl header.i=@o2.pl header.a=rsa-sha256 header.s=s20261001 header.b=AWKwe+4m
Received: (wp-smtpd smtp.tlen.pl 41060 invoked from network); 15 Nov 2026 19:26:31 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=s20261001;
          t=1794767191; bh=d6Mw+ubXF8sNdhhSz6FQxX5iaQzd+/Pf5yiAG6Xqtuo=;
          h=Subject:To:Cc:From;
          b=AWKwe+4mwqxLmslMtGtvuifajW+ZAgiOmWlm0GNIpHdB2oDLh0rix+p9oogXI+aOn
           73Lzanp04BhOvi2KiDdzwKNYuYAzNjlV231AZpa3zzLt9qCOuAorIWDltCqJxNTTHT
           Y+9BgzHWtnVNV/EjZYl7Xf5CgO00zJKv6V+uei/RltlcmtcD/mVMgJ9w2Ut9n2CxSw
           Wyx6s+jnXqGX6qrxzkGnYHi+/WvsXLH3CgmE/tGPEL+UFqmgFvl04ch9fNlHWh+TSj
           tweyyBA02IESsN2qHPcbL/mwVjBedvrPm+sls9evWxX3hFtcQkNgL0l8pGehQa7Rgb
           4DWImfTUlrxfA==
Received: from [192.168.1.22] (apn-78-30-67-84.dynamic.gprs.plus.pl [78.30.67.84])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <stern@rowland.harvard.edu>; 15 Nov 2026 19:26:31 +0100
Message-ID: <ae7ce6c0-d1ad-459d-a526-1d52fbb445b6@o2.pl>
Date: Sun, 15 Nov 2026 19:26:29 +0100
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] usb: uas: expose US_FL_NO_ATA_1X in sysfs as
 deny_ata_passthrough
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
 linux-kernel@vger.kernel.org, smartmontools-support@listi.jpberlin.de,
 Christian Franke <Christian.Franke@t-online.de>
References: <20261115124046.5286-1-mat.jonczyk@o2.pl>
 <1e731b43-93ad-4230-833a-df6949c7d4c6@rowland.harvard.edu>
Content-Language: en-GB, pl
From: =?UTF-8?Q?Mateusz_Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
Autocrypt: addr=mat.jonczyk@o2.pl; keydata=
 xsFNBFqMDyQBEAC2VYhOvwXdcGfmMs9amNUFjGFgLixeS2C1uYwaC3tYqjgDQNo/qDoPh52f
 ExoTMJRqx48qvvY/i6iwia7wOTBxbYCBDqGYxDudjtL41ko8AmbGOSkxJww5X/2ZAtFjUJxO
 QjNESFlRscMfDv5vcCvtH7PaJJob4TBZvKxdL4VCDCgEsmOadTy5hvwv0rjNjohau1y4XfxU
 DdvOcl6LpWMEezsHGc/PbSHNAKtVht4BZYg66kSEAhs2rOTN6pnWJVd7ErauehrET2xo2JbO
 4lAv0nbXmCpPj37ZvURswCeP8PcHoA1QQKWsCnHU2WeVw+XcvR/hmFMI2QnE6V/ObHAb9bzg
 jxSYVZRAWVsdNakfT7xhkaeHjEQMVRQYBL6bqrJMFFXyh9YDj+MALjyb5hDG3mUcB4Wg7yln
 DRrda+1EVObfszfBWm2pC9Vz1QUQ4CD88FcmrlC7n2witke3gr38xmiYBzDqi1hRmrSj2WnS
 RP/s9t+C8M8SweQ2WuoVBLWUvcULYMzwy6mte0aSA8XV6+02a3VuBjP/6Y8yZUd0aZfAHyPi
 Rf60WVjYNRSeg27lZ9DJmHjSfZNn1FrtZi3W9Ff6bry/SY9D136qXBQxPYxXQfaGDhVeLUVF
 Q+NIZ6NEjqrLQ07LEvUW2Qzk2q851/IaXZPtP6swx0gqrpjNrwARAQABzSRNYXRldXN6IEpv
 xYRjenlrIDxtYXQuam9uY3p5a0BvMi5wbD7CwX4EEwECACgFAlqMDyQCGwMFCRLMAwAGCwkI
 BwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJEPvWWrhhCv7Gb0MQAJVIpJ1KAOH6WaT8e65xZulI
 1jkwGwNp+3bWWc5eLjKUnXtOYpa9oIsUUAqvh/L8MofGtM1V11kSX9dEloyqlqDyNSQk0h52
 hZxMsCQyzjGOcBAi0zmWGYB4xu6SXj4LpVpIPW0sogduEOfbC0i7uAIyotHgepQ8RPGmZoXU
 9bzFCyqZ8kAqwOoCCx+ccnXtbnlAXQmDb88cIprAU+Elk4k4t7Bpjn2ek4fv35PsvsBdRTq3
 ADg8sGuq4KQXhbY53n1tyiab3M88uv6Cv//Ncgx+AqMdXq2AJ7amFsYdvkTC98sx20qk6Cul
 oHggmCre4MBcDD4S0qDXo5Z9NxVR/e9yUHxGLc5BlNj+FJPO7zwvkmIaMMnMlbydWVke0FSR
 AzJaEV/NNZKYctw2wYThdXPiz/y7aKd6/sM1jgPlleQhs3tZAIdjPfFjGdeeggv668M7GmKl
 +SEzpeFQ4b0x64XfLfLXX8GP/ArTuxEfJX4L05/Y9w9AJwXCVEwW4q17v8gNsPyVUVEdIroK
 cve6cgNNSWoxTaYcATePmkKnrAPqfg+6qFM4TuOWmyzCLQ1YoUZMxH+ddivDQtlKCp6JgGCz
 c9YCESxVii0vo8TsHdIAjQ/px9KsuYBmOlKnHXKbj6BsE/pkMMKQg/L415dvKzhLm2qVih7I
 U16IAtK5b7RpzsFNBFqMDyQBEACclVvbzpor4XfU6WLUofqnO3QSTwDuNyoNQaE4GJKEXA+p
 Bw5/D2ruHhj1Bgs6Qx7G4XL3odzO1xT3Iz6w26ZrxH69hYjeTdT8VW4EoYFvliUvgye2cC01
 ltYrMYV1IBXwJqSEAImU0Xb+AItAnHA1NNUUb9wKHvOLrW4Y7Ntoy1tp7Vww2ecAWEIYjcO6
 AMoUX8Q6gfVPxVEQv1EpspSwww+x/VlDGEiiYO4Ewm4MMSP4bmxsTmPb/f/K3rv830ZCQ5Ds
 U0rzUMG2CkyF45qXVWZ974NqZIeVCTE+liCTU7ARX1bN8VlU/yRs/nP2ISO0OAAMBKea7slr
 mu93to9gXNt3LEt+5aVIQdwEwPcqR09vGvTWdRaEQPqgkOJFyiZ0vYAUTwtITyjYxZWJbKJh
 JFaHpMds9kZLF9bH45SGb64uZrrE2eXTyI3DSeUS1YvMlJwKGumRTPXIzmVQ5PHiGXr2/9S4
 16W9lBDJeHhmcVOsn+04x5KIxHtqAP3mkMjDBYa0A3ksqD84qUBNuEKkZKgibBbs4qT35oXf
 kgWJtW+JziZf6LYx4WvRa80VDIIYCcQM6TrpsXIJI+su5qpzON1XJQG2iswY8PJ40pkRI9Sm
 kfTFrHOgiTpwZnI9saWqJh2ABavtnKZ1CtAY2VA8gmEqQeqs2hjdiNHAmRxR2wARAQABwsFl
 BBgBAgAPBQJajA8kAhsMBQkSzAMAAAoJEPvWWrhhCv7GhpYP/1tH/Kc35OgWu2lsgJxR9Z49
 4q+yYAuu11p0aQidL5utMFiemYHvxh/sJ4vMq65uPQXoQ3vo8lu9YR/p8kEt8jbljJusw6xQ
 iKA1Cc68xtseiKcUrjmN/rk3csbT+Qj2rZwkgod8v9GlKo6BJXMcKGbHb1GJtLF5HyI1q4j/
 zfeu7G1gVjGTx8e2OLyuBJp0HlFXWs2vWSMesmZQIBVNyyL9mmDLEwO4ULK2quF6RYtbvg+2
 PMyomNAaQB4s1UbXAO87s75hM79iszIzak2am4dEjTx+uYCWpvcw3rRDz7aMs401CphrlMKr
 WndS5qYcdiS9fvAfu/Jp5KIawpM0tVrojnKWCKHG4UnJIn+RF26+E7bjzE/Q5/NpkMblKD/Y
 6LHzJWsnLnL1o7MUARU++ztOl2Upofyuj7BSath0N632+XCTXk9m5yeDCl/UzPbP9brIChuw
 gF7DbkdscM7fkYzkUVRJM45rKOupy5Z03EtAzuT5Z/If3qJPU0txAJsquDohppFsGHrzn/X2
 0nI2LedLnIMUWwLRT4EvdYzsbP6im/7FXps15jaBOreobCaWTWtKtwD2LNI0l9LU9/RF+4Ac
 gwYu1CerMmdFbSo8ZdnaXlbEHinySUPqKmLHmPgDfxKNhfRDm1jJcGATkHCP80Fww8Ihl8aS
 TANkZ3QqXNX2
In-Reply-To: <1e731b43-93ad-4230-833a-df6949c7d4c6@rowland.harvard.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-WP-MailID: a7c25a38ebf7bf4f20a8e77008d68389
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 000000A [8eOU]                               

W dniu 15.11.2026 o 16:52, Alan Stern pisze:
> On Sun, Nov 15, 2026 at 01:40:46PM +0100, Mateusz Jończyk wrote:
>> The uas driver blocks access to ATA passthrough commands for some
>> devices it considers buggy (via the US_FL_NO_ATA_1X flag in
>> unusual_uas.h and uas_detect.h). However, it does not expose any
>> meaningful information whether the command was blocked by the driver or
>> is genuinly not supported by the hardware. This creates a problem for
>> the smartmontools program and makes it difficult for it to provide a
>> useful error message (with instructions to disable UAS on the drive to
>> get SMART readings).
>>
>> So, expose the information in sysfs as deny_ata_passthrough. Other
>> quirks may be added in the future if there is any demand.
>>
>> Link: https://www.smartmontools.org/wiki/SAT-with-UAS-Linux
>> Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
> Why was this change made to uas but not to usb-storage?  Was it because
> some devices can handle ATA passthrough commands over the Bulk-Only
> transport but not over the UAS transport?  Note that the
> US_FL_NO_ATA_1X flag applies to both transports.
>
> Alan Stern

There are only very few devices that cannot handle ATA passthrough commands
over the Bulk-Only transfer (and with them it's impossible to get ATA
passthrough by disabling UAS). But that's a fair point, will fix it in v2.

Considering the US_FL_NO_ATA_1X flag:

- I suspect that many more devices would accept the ATA passthrough 
commands in
   UAS mode if these would be issued in isolation (if uas_queuecommand_lck()
   would stop all other transfers while doing them). After all, Windows
   apparently does not carry such quirks for modern devices. I do not 
have the
   hardware to test, though.

- Since 2017, it is set unequivocally for all Seagate drives, even 
though most
   likely modern drives / firmware versions do not need it. I do not see 
a way
   out, though.

Greetings,

Mateusz

