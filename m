From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: PATCH: scsi device queue depth adjustability patch
Date: 02 Oct 2002 14:44:25 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1033566265.23682.18.camel@irongate.swansea.linux.org.uk>
References: <20021002002854.GF28265@redhat.com>
	<1033521367.20103.57.camel@irongate.swansea.linux.org.uk>
	<20021002014144.GA29093@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20021002014144.GA29093@redhat.com>
To: Doug Ledford <dledford@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2002-10-02 at 02:41, Doug Ledford wrote:
> I didn't provide a lot of details before because this machine doesn't have
> a serial console host to grab logs and I didn't write all the stuff down.  
> Then there is the additional fubar stuff but it's mainly in the category
> of "Red Hat Linux 8.0 made initrd images using nash as the shell blow
> chunks in regards to actually working with the 2.5.40 kernel, failing
> simple operations such as mounting /proc, which of course causes damn near
> everything else it tries to do to fail since the normal /proc files aren't
> available".

Ok first thing to try - does 2.4.20-pre8-ac3 also lock up. That will
seperate problems with the 2.5.40 kernel from IDE ones. In paticular I
notice you mention using initrd which doesnt seem to work in 2.5.40
