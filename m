From: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
Subject: Re: [Cluster-devel] [PATCH 00/12] drop unneeded newline
Date: Tue, 2 Jan 2018 15:00:46 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1801021458360.24055@hadrien>
References: <1514386305-7402-1-git-send-email-Julia.Lawall@lip6.fr>
	<1878806802.2632123.1514901158666.JavaMail.zimbra@redhat.com>
	<1019862289.2632779.1514901387442.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
In-Reply-To: <1019862289.2632779.1514901387442.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://mail.openvswitch.org/mailman/options/ovs-dev>,
	<mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://mail.openvswitch.org/pipermail/ovs-dev/>
List-Post: <mailto:ovs-dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
List-Help: <mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=help>
List-Subscribe: <https://mail.openvswitch.org/mailman/listinfo/ovs-dev>,
	<mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=subscribe>
Sender: ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org
Errors-To: ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org
To: Bob Peterson <rpeterso-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dccp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, esc storagedev <esc.storagedev-dzo6w/eZyo2tG0bUXCXiUA@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jiri Olsa <jolsa-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org



On Tue, 2 Jan 2018, Bob Peterson wrote:

> ----- Original Message -----
> | ----- Original Message -----
> | | Drop newline at the end of a message string when the printing function adds
> | | a newline.
> |
> | Hi Julia,
> |
> | NACK.
> |
> | As much as it's a pain when searching the source code for output strings,
> | this patch set goes against the accepted Linux coding style document. See:
> |
> | https://www.kernel.org/doc/html/v4.10/process/coding-style.html#breaking-long-lines-and-strings
> |
> | Regards,
> |
> | Bob Peterson
> |
> |
> Hm. I guess I stand corrected. The document reads:
>
> "However, never break user-visible strings such as printk messages, because that breaks the ability to grep for them."
>
> Still, the GFS2 and DLM code has a plethora of broken-up printk messages,
> and I don't like the thought of re-combining them all.

Actually, the point of the patch was to remove the unnecessary \n at the
end of the string, because log_print will add another one.  If you prefer
to keep the string broken up, I can resend the patch in that form, but
without the unnecessary \n.

julia
