From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [LSF/MM TOPIC] linux servers as a storage server - what's
 missing?
Date: Thu, 22 Dec 2011 10:58:49 -0500
Message-ID: <20111222155849.GD1388@redhat.com>
References: <4EF2026F.2090506@redhat.com>
 <DBFB1B45AF80394ABD1C807E9F28D157077DD22B19@BLRX7MCDC203.AMER.DELL.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DBFB1B45AF80394ABD1C807E9F28D157077DD22B19@BLRX7MCDC203.AMER.DELL.COM>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Shyam_Iyer@Dell.com
Cc: rwheeler@redhat.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 22, 2011 at 01:44:16PM +0530, Shyam_Iyer@Dell.com wrote:

[..]

> Simple asks -
> 1) Provide a consistent storage and fs management library that discourages folks to write their own usespace storage library. Include things like fs formatting(fs profiles), transport configuration(eg: iscsiadm as a library), thin provisioning watermarks, cluster management, apis for cgroups etc.
                                      ^^^^^^^^^^^^^^^^
For cgroups, we have libcgroup library. Not many people like to use it 
though as cgroup is exported as a filesystem and they prefer to use normal
libc api to traverse and configure cgroups (Instead of going through
another library). Some examples include libvrit, systemd.

Thanks
Vivek
