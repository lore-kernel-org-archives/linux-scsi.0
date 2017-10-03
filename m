From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Patch v2 1/2] libiscsi: Fix use-after-free race during iscsi_session_teardown
Date: Mon, 02 Oct 2017 22:28:49 -0400
Message-ID: <yq1shf10xsu.fsf@oracle.com>
References: <20170713161122.89375-1-khazhy@google.com>
	<20170829182914.5oza32ohjj4lua6j@straylight.hirudinean.org>
	<yq1r2vtzv3p.fsf@oracle.com>
	<CACGdZYJ-jF8KTdHQHhmgHmFTszAUhpijby0vFA2pkysbQzeYjw@mail.gmail.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBDVIJONZ3YDRBZ7LZPHAKGQE6APPZVY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <CACGdZYJ-jF8KTdHQHhmgHmFTszAUhpijby0vFA2pkysbQzeYjw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Khazhismel Kumykov's message of "Fri, 29 Sep 2017 15:54:28 -0700")
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Khazhismel Kumykov <khazhy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Khazhismel Kumykov' via open-iscsi <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, lduncan-IBi9RG/b67k@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


Khazhismel,

> Noticed these don't seem to be in 4.14/scsi-queue

Not sure what happened there. I apologize.

They are now in 4.14/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
