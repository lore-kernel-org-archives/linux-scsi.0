From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH] x86: Moving probe_roms_32 to probe_roms
Date: Fri, 25 Feb 2011 08:38:10 -0800
Message-ID: <4D67DAF2.8090501@intel.com>
References: <20110222201538.15443.81915.stgit@localhost6.localdomain6>	 <AANLkTikimHCsFmavDoXn3Pka8WWMePqk+hNUK8h=DqSQ@mail.gmail.com>	 <4D670B07.90005@zytor.com> <1298628822.11506.21.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1298628822.11506.21.camel@dwillia2-linux>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Jiang, Dave" <dave.jiang@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 02/25/2011 02:13 AM, Williams, Dan J wrote:
[..]
> +		if (probe_kernel_address(rom + offset + 0x8, list) != 0 &&
> +		    probe_kernel_address(rom + offset + 0xc, rev) != 0 &&

These should be "== 0", but you get the idea...


> +		    rev>= 3&&  list&&
> +		    probe_list(pdev, vendor, rom + offset + list)) {
> +			oprom = res;
> +			break;
> +		}
> +	}

--
Dan
