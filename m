From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 0/9] Fix references for some missing documentation files
Date: Mon, 2 Jul 2018 11:27:23 -0600
Message-ID: <20180702112723.654d348c@lwn.net>
References: <cover.1530005114.git.mchehab+samsung@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <cover.1530005114.git.mchehab+samsung@kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, James Morris <james.morris@microsoft.com>, kvm@vger.kernel.org, Linux Doc Mailing List <linux-doc@vger.kernel.org>, virtualization@lists.linux-foundation.org, linux-leds@vger.kernel.org, linux-scsi@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, intel-wired-lan@lists.osuosl.org, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, linux-input@vger.kernel.org, devicetree@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-gpio@vger.kernel.org, Jacek Anaszewski <jacek.anaszewski@gmail.com>, Andy Whitcroft <apw@canonical.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Changbin Du <changbin.du@intel.com>, Masami Hiramatsu <mhiramat@kernel.org>, linux-kernel@zh-kernel.org, Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 26 Jun 2018 06:49:02 -0300
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> wrote:

> Having nothing to do while waiting for my plane to arrive while
> returning back from Japan, I ended by writing a small series of 
> patches meant to reduce the number of bad Documentation/* 
> links that are detected by:
> 	./scripts/documentation-file-ref-check

I've applied everything except the two networking patches, since I expect
those to go through Dave's tree.

Thanks,

jon
