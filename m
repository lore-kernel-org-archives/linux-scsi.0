From: <Shyam_Iyer@Dell.com>
Subject: RE: [LSF/MM TOPIC] linux servers as a storage server - what's
 missing?
Date: Fri, 23 Dec 2011 02:24:42 +0530
Message-ID: <DBFB1B45AF80394ABD1C807E9F28D157077DD22D79@BLRX7MCDC203.AMER.DELL.COM>
References: <4EF2026F.2090506@redhat.com>
 <DBFB1B45AF80394ABD1C807E9F28D157077DD22B19@BLRX7MCDC203.AMER.DELL.COM>
 <20111222155849.GD1388@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20111222155849.GD1388@redhat.com>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
To: vgoyal@redhat.com
Cc: rwheeler@redhat.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Vivek Goyal
> Sent: Thursday, December 22, 2011 10:59 AM
> To: Iyer, Shyam
> Cc: rwheeler@redhat.com; linux-fsdevel@vger.kernel.org; linux-
> scsi@vger.kernel.org
> Subject: Re: [LSF/MM TOPIC] linux servers as a storage server - what's
> missing?
> 
> On Thu, Dec 22, 2011 at 01:44:16PM +0530, Shyam_Iyer@Dell.com wrote:
> 
> [..]
> 
> > Simple asks -
> > 1) Provide a consistent storage and fs management library that
> discourages folks to write their own usespace storage library. Include
> things like fs formatting(fs profiles), transport configuration(eg:
> iscsiadm as a library), thin provisioning watermarks, cluster
> management, apis for cgroups etc.
>                                       ^^^^^^^^^^^^^^^^
> For cgroups, we have libcgroup library. Not many people like to use it
> though as cgroup is exported as a filesystem and they prefer to use
> normal
> libc api to traverse and configure cgroups (Instead of going through
> another library). Some examples include libvrit, systemd.
> 
> Thanks
> Vivek

Well honestly I think that is a libvirt/systemd issue and libvirt also invokes things like iscsiadm, dcb etc as a binary :-/

Some one could always use qemu command lines to invoke KVM/XEN but libvirt has saved me one too many days in doing a quick operation without wondering about a qemu commandline.
 
I am also asking for ideas on how to avoid this fragmentation because just like libvirt others are also encouraged to do their own libc thing in the absence of a common storage management framework..

Does the standard interface for linux end at the user/kernel boundary or the user/libc boundary? If so I feel we would continue to lag behind other OSes in features because of the model. 

