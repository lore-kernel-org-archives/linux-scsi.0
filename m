From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 2/2] libata: avoid waking disk to check power
Date: Mon, 04 Nov 2013 21:45:25 -0500
Message-ID: <52785BC5.9020205@ubuntu.com>
References: <1383612780-6591-1-git-send-email-psusi@ubuntu.com> <1383612780-6591-2-git-send-email-psusi@ubuntu.com> <52785A5F.4060001@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <52785A5F.4060001@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 11/04/2013 09:39 PM, Aaron Lu wrote:
> If the disk entered sleep mode due to runtime PM, then udisks can
> easily tell by checking the device's runtime status and not send
> out the query.
> 
> But if the disk entered sleep mode due to other reason, the patch
> may be necessary. So what's your scenario?

I am planning on patching udisks to do that as well, but if you have a
current udsisk or manually run hdparm -C, or some other program is
doing something similar, then this patch takes care of that.



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJSeFvFAAoJEJrBOlT6nu75hcYH/0YsYcs3u9Dmuqq9z5kFXL3k
C4xYQtvOxw2z+B/vEFzdym5J3ZfVyT4+ZdcHMvRgbbPH+R8/rzNC+F3OjdGtDIRA
5EUo0BUT2IfY0Yp2SzP44+8aRC4iF5jLLcH9XJKQx7WHedJQ7puCgJXXHAgUhpwW
52gJ0UEHnjlBgjwxY9RKqppnJs57x2VwgwR2BeFns6Hcry0S0HN0U4gwROmb1GZR
kjpOUUYHb3MH/gfzCaY97t0duAAp7jzZeOIuu+XHfkyV3APwsnbasLOOoRYtpbvQ
M++xmYQdNAh2DcZLEmAo6H6HLB/Z5d9K0+SKUFnsKHFaUCH0GPHm8SZ7E/NN7ig=
=7c7v
-----END PGP SIGNATURE-----
