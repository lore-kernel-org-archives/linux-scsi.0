From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH/RESEND v2 0/2] SATA disk resume time optimization
Date: Mon, 11 Nov 2013 12:08:49 -0500
Message-ID: <52810F21.9070605@ubuntu.com>
References: <20131017193331.GA11747@linux.intel.com> <527AF287.7020700@ubuntu.com> <20131109012023.GA8978@linux.intel.com> <527EA218.6010604@ubuntu.com> <20131111165920.GA25366@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20131111165920.GA25366@linux.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: todd.e.brandt@linux.intel.com
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, tj@kernel.org, JBottomley@parallels.com
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/11/2013 11:59 AM, Todd E Brandt wrote:
> 500ms is actually quite alot when you compare it with android or
> iOS, or even with other subsystems like USB. USB is the second
> worst offender after SATA disks and it tends to take around 600ms
> for most standard systems with an onboard webcam, and with other
> devices plugged in ever longer. I think we should optimize out
> every millisecond we can.

I think you missed my point: if the disk is going to be started in
9000ms vs 8500ms, it doesn't make much difference, and I think in
practice the difference will be less than that.  I don't think it is
worth requiring that all disks start up to save a few percent in the
cases where the disk is required ( and I'm not clear that there even
are any such cases ).

> You mentioned that you tuned your system to remove all cases that
> trigger non-essential disk wakeups, and that works great for you,
> but it won't help anyone using fedora or OpenSUSE or Yocto, etc.
> And even if you could formallize your changes to Ubuntu to create a
> fully optimized user space, you're still at the mercy of the user's
> install choices, which can quickly throw a wrench in the works.

No, I did not tune my system; I fixed the kernel so that userspace's
activities do not start those disks.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSgQ8hAAoJEJrBOlT6nu75c04H/2ej9NzdyrWkuPv2SLGgb51Y
iBmeAkJEoFXwgu0UCZ2Ty3dpUkW7jcRiKKv5q8d1Anj4eGFIpx+CjUptCE3MCs1w
PWQm7uB6+DgOhj3aqF9DulBx0Yp3+gISwOTXYLAIirIReE4Vk904ZuYHo4IvJmug
vbk4p6n5iGLMqV/QFsymPoOFtUzKQPHj4YDL3Piu0fse8AOIHk5BJtmmtj1YbAck
oAsMIYz6UQZ2tXpzxcy1ISgZYUO8k6CcrXg8WE2ws9gZLNJtBHniLC1t2VCE10KF
BSzP+tgN+Glbk+HyJUuwjALa/CkFk9FKQJT8LJQfn0rRhjku/vZXsZoFgCQiIx0=
=THLl
-----END PGP SIGNATURE-----
