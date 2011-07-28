From: Fubo Chen <fubo.chen@gmail.com>
Subject: Re: [PATCH 12/13] iscsi-target: Add misc utility logic
Date: Thu, 28 Jul 2011 13:30:33 +0200
Message-ID: <CAJAFBLCJVLA7RwmVBUPobzqV+j5T5GoV=uRoRqUDuQkJn41Qpw@mail.gmail.com>
References: <1311410747-29947-1-git-send-email-nab@linux-iscsi.org>
	<1311410747-29947-13-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38294 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348Ab1G1Lae convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2011 07:30:34 -0400
In-Reply-To: <1311410747-29947-13-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>

On Sat, Jul 23, 2011 at 10:45 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> +static int iscsit_do_rx_data(
> + =A0 =A0 =A0 struct iscsi_conn *conn,
> + =A0 =A0 =A0 struct iscsi_data_count *count)
> +{
> + =A0 =A0 =A0 int data =3D count->data_length, rx_loop =3D 0, total_r=
x =3D 0, iov_len;
> + =A0 =A0 =A0 u32 rx_marker_val[count->ss_marker_count], rx_marker_io=
v =3D 0;
> + =A0 =A0 =A0 struct kvec iov[count->ss_iov_count], *iov_p;

How big can count->ss_iov_count be ? Can this make a stack overflow ?

=46ubo.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
