From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] ibmvscsis: Fix max transfer length
Date: Fri, 13 Jan 2017 21:16:53 +0000
Message-ID: <1484342200.2679.21.camel@sandisk.com>
References: <1484163851.2619.21.camel@sandisk.com>
         <1484164347-66581-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1484164347-66581-1-git-send-email-bryantly@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <5422305DAB5BAA499A734420CDB170F6@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: "bryantly@linux.vnet.ibm.com" <bryantly@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-01-11 at 13:52 -0600, Bryant G. Ly wrote:
> Current code incorrectly calculates the max transfer length, since
> it is assuming a 4k page table, but ppc64 all run on 64k page tables.

This patch has been queued for kernel v4.10. Thanks for the patch.

Bart.=
