From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH v5 2/3] libata: async resume
Date: Fri, 19 Dec 2014 20:42:40 -0500
Message-ID: <5494D410.6060209@ubuntu.com>
References: <20140305201443.20088.85361.stgit@viggo.jf.intel.com> <20140305201735.20088.22124.stgit@viggo.jf.intel.com> <5494B8D1.1070608@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <5494B8D1.1070608@ubuntu.com>
Sender: linux-ide-owner@vger.kernel.org
To: Todd Brandt <todd.e.brandt@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, tj@kernel.org, JBottomley@Parallels.com, Len Brown <len.brown@intel.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 12/19/2014 06:46 PM, Phillip Susi wrote:
> I realize this is a little late but I finally started looking at
> the patch set I was working on last year again, and now that I look
> at your version that was accepted, I realize that it only addresses
> the libata side of things.  sd still issues START_STOP_UNIT
> synchronously in the resume path, so without the patch fixing that,
> you shouldn't see any actual speed up in resume times.  Or are you
> using the manage_start_stop flag to inhibit that ( at the cost of
> taking an emergency park on each suspend/shutdown )?

Sorry for the noise, I missed the patch to the scsi core that makes
the entire call to sd_resume async.  Very nice.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUlNQQAAoJENRVrw2cjl5RUP8H/3hz6qRtSbRJPYya2RCsjgWE
dM5tm9RXJurPYCa615NmMX+bym2ooSVlYFZPAkuEtIh+uOeO7S9z5WX6de7ErtyN
yNZNSPQXMZDLOzwy0gnZr2BU0Htk4LpX+2mdmos9oVQJJXqc2n1Nje3NXF/F6qm8
I8fjKTyOLQgI8GbJNFkK028rjvxc1DYTGx2hgC2KYpuktdyrJv6c68TZBUF1jFQm
UVsp1xpN5BoGGbhb13LBVm1To8V5YyEvR6Ou1Y633VM4089HLUWMwVBwVIjryyiY
gR6dHdqs/a/1nuXFGZXAMZXhLFuNJ2a/h98QcX5ZxuaKP8XFEN6V/JyXxiekxK8=
=Vtbl
-----END PGP SIGNATURE-----
