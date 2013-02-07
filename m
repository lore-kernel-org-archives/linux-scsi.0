From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM TOPIC] Thin provisioning SOFT_THRESHOLD error handling
Date: Thu, 07 Feb 2013 14:12:46 +0100
Message-ID: <5113A84E.1070501@suse.de>
References: <510784DE.3000509@suse.de> <5113A6DB.5030703@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <5113A6DB.5030703@panasas.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: lsf-pc@lists.linux-foundation.org, Linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 02/07/2013 02:06 PM, Boaz Harrosh wrote:
[ .. ]
>
> Hannes hi!
>
> This is received as an "unit attentions", right?
> Will it not be worth while to solve the general "unit attentions"
> under udev events, once and for all. Than such a btrfs GC above
> can just be a simple oneline udev rule.
>
You might want to look at Ewan Milnes patch-set ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
