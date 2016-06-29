From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCH v8] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Wed, 29 Jun 2016 10:22:06 -0500
Message-ID: <A01096DE-CB0D-4C2D-88D8-CA57DFFF9AE7@linux.vnet.ibm.com>
References: <1464274721-36453-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <1467058632-1825-1-git-send-email-mikecyr@linux.vnet.ibm.com>
 <BB635617-87FA-4667-B1B0-657E2E9FF627@linux.vnet.ibm.com>
 <2aa7660d-2c9a-08bf-59f6-7282a0a7a6f4@sandisk.com>
 <008A3B47-6BAE-42FA-8D65-66D0F0C7747B@linux.vnet.ibm.com>
 <bc9d5ba0-4220-18ac-aab0-0e7572c8c26d@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <bc9d5ba0-4220-18ac-aab0-0e7572c8c26d@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Michael Cyr <mikecyr@linux.vnet.ibm.com>
Cc: "seroyer@linux.vnet.ibm.com" <seroyer@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 6/29/16, 9:54 AM, "Bart Van Assche" <target-devel-owner@vger.kernel.=
org on behalf of bart.vanassche@sandisk.com> wrote:

On 06/29/2016 04:43 PM, Bryant G. Ly wrote:
>> It looks like the masking fixes the device mapper=E2=80=99s ability =
to find the disk=E2=80=A6.

> Is the multipath client available in your initrd? If so, running=20
> multipath -ll -v<n> with n >=3D 3 should reveal why multipathd ignore=
d=20
> certain disks.

I enabled it on the initiator:

[root@vscsi-bry ~]# multipath -ll
[root@vscsi-bry ~]# multipath -ll -v<n> with n >=3D 3
-bash: n: No such file or directory
[root@vscsi-bry ~]# mpathconf
multipath is enabled
find_multipaths is enabled
user_friendly_names is enabled
dm_multipath module is loaded
multipathd is running
[root@vscsi-bry ~]#

But it seems to not do much.

--
To unsubscribe from this list: send the line "unsubscribe target-devel"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
