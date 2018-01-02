From: Bob Peterson <rpeterso@redhat.com>
Subject: Re: [Cluster-devel] [PATCH 00/12] drop unneeded newline
Date: Tue, 2 Jan 2018 08:56:27 -0500 (EST)
Message-ID: <1019862289.2632779.1514901387442.JavaMail.zimbra@redhat.com>
References: <1514386305-7402-1-git-send-email-Julia.Lawall@lip6.fr> <1878806802.2632123.1514901158666.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1878806802.2632123.1514901158666.JavaMail.zimbra@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: dev@openvswitch.org, linux-s390@vger.kernel.org, linux-media@vger.kernel.org, linux-scsi@vger.kernel.org, dccp@vger.kernel.org, Alexander Shishkin <alexander.shishkin@linux.intel.com>, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, cluster-devel@redhat.com, amd-gfx@lists.freedesktop.org, Namhyung Kim <namhyung@kernel.org>, linux-ext4@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>, linux-arm-kernel@lists.infradead.org, esc storagedev <esc.storagedev@microsemi.com>
List-Id: linux-scsi@vger.kernel.org

----- Original Message -----
| ----- Original Message -----
| | Drop newline at the end of a message string when the printing function adds
| | a newline.
| 
| Hi Julia,
| 
| NACK.
| 
| As much as it's a pain when searching the source code for output strings,
| this patch set goes against the accepted Linux coding style document. See:
| 
| https://www.kernel.org/doc/html/v4.10/process/coding-style.html#breaking-long-lines-and-strings
| 
| Regards,
| 
| Bob Peterson
| 
| 
Hm. I guess I stand corrected. The document reads:

"However, never break user-visible strings such as printk messages, because that breaks the ability to grep for them."

Still, the GFS2 and DLM code has a plethora of broken-up printk messages,
and I don't like the thought of re-combining them all.

Regards,

Bob Peterson
