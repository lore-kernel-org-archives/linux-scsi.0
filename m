From: Matthew Jacob <mjacob@feral.com>
Subject: Re: [RFC] SCSI Hotplug for lk 2.5
Date: Fri, 2 Aug 2002 14:21:16 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0208021420380.66758-100000@beppo>
References: <20020802133701.C31990@one-eyed-alien.net>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020802133701.C31990@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org


> It would be really nice if a low-level driver could signal, somehow, to the
> VFS layer that it was a hot-unpluggable device, and thus precautions should
> be taken (i.e. perfer mounting with -o sync, etc.)
> 

I don't think this s wise. By definition all SAN devices are
'hot-unpluggable', and you sure don't want to mount them sync only.


